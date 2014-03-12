Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaCLLf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:35:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33296 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208AbaCLLf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:35:26 -0400
Date: Wed, 12 Mar 2014 12:35:24 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: add initial support for the Marvell BG2-Q DMP
Message-ID: <20140312113523.GL13905@piout.net>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/03/2014 at 12:06:02 +0100, Antoine Ténart wrote :
> This serie adds the initial support for the Marvell BG2-Q DMP (part of the
> Berlin family). SoC has nodes for cpu, l2 cache controller, interrupt
> controllers, local timer, apb timers and uarts for now.
> 
> Homepage: http://www.marvell.com/digital-entertainment/armada-1500-pro/
> 

I would move that description to the commit logs. Else one would have to
lookup the mailing list archive to read it.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
