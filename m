Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3EYJJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 05:09:47 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36196 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3EYJJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 05:09:39 -0400
MIME-Version: 1.0
Date: Sat, 25 May 2013 11:09:38 +0200
Message-ID: <CADDKRnBf4i8ZQ4EXC15Sa6z9CZ55w0vBDnXG26sjWgdO9zH45w@mail.gmail.com>
Subject: [v3.10-rc2] iwlwifi regression
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If iwlwifi/iwldvm are built into the kernel (no loadable modules)
following error is written to console and syslog since v3.10-rc:

iwlwifi 0000:08:00.0: failed to load module iwldvm (error -38), is
dynamic loading enabled?

reverting
commit 1618b2b02a3a0ee7a6863fed4b0d22e697e7e97c
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Apr 4 10:35:23 2013 +0200
    iwlwifi: print warning on request_module failure

fixes the problem for me.

Jörg

I'm not subscribed,please CC me in answeres
