Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3LUAjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 19:39:23 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:34249 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3LUAjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 19:39:22 -0500
MIME-Version: 1.0
Date: Sat, 21 Dec 2013 01:39:21 +0100
Message-ID: <CAMesUR48C3zBo_UJByjC9GSqK6V=W_-WDQrsAoGye2yNADD3NQ@mail.gmail.com>
Subject: perf and Kconfig
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a proposal of a small contribution which tries to fulfill the
task "Use Kconfig to allow selecting features and build minimal
version of perf,..." displayed on the todo page of the perf
wiki (https://perf.wiki.kernel.org/index.php/Todo).

I tried to continue the work started by David Ahern
(https://github.com/dsahern/linux.git branch:perf-config). This
version relies on the features detection tests available in
linux/tools/perf/config/feature-checks so as to enable some
configuration options (at least by default).

This little task is not complete; more Kconfig options should be added
for each perf tool (top, record, report, ...).

I just wanted to ask whether you consider this proposal as interesting
enough for inclusion and if you are ok with the way it is implemented.

The code is available here: https://github.com/aberlemont/linux.git
- branch: perf-config.

Alexis.
