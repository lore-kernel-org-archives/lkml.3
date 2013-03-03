Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3CCXiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 18:38:17 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53782 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3CCXiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 18:38:15 -0500
Date: Mon, 4 Mar 2013 00:38:12 +0100
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: linux-kernel@vger.kernel.org
Subject: Questions about multiprocessor architectures
Message-ID: <20130303233812.GA10609@paksenarrion.iveqy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've got some questions about multiprocessor architectures, or more
correct linux behavior on them.

Is there any restriction on how two processors are connected to
eachother. My interests are Intels qpi (which I suppose that linux
supports, at least from my research) and thunderbolt (which should be
fast enough for inter CPU communication). Does linux support those
interfaces?

Is it possible to connect two processors with different architecture?
For example and ARM processor with a amd64 processor?

I'm a novince on the subject and takes gladly pointers to good
litterature or places to educate myself and apologizes if my questions
seems strange formulated.

--
Med vänliga hälsningar
Fredrik Gustafsson

tel: 0733-608274
e-post: iveqy@iveqy.com
