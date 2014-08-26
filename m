Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbaHZFsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:48:55 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:42507 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaHZFsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:48:54 -0400
Date: Tue, 26 Aug 2014 01:48:37 -0400
From: Shea Levy <shea@shealevy.com>
To: linux-kernel@vger.kernel.org
Subject: Documentation for init
Message-ID: <20140826054837.GA2766@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Is there any official documentation of the init process? I'm
specifically interested in the process state at kernel handoff (argv,
envp, open fds, etc.) as well as any special properties pid 1 has
(parent of all orphans, anything else?).

Thanks,
Shea Levy

P.S. I am not subscribed to LKML, please CC me in responses
