Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaGBHzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:55:40 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaGBHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:55:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v7] media: vb2: Take queue or device lock in mmap-related vb2 ioctl handlers
Date: Wed, 02 Jul 2014 09:56:33 +0200
Message-ID: <10104979.PzNG1tgbGn@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.21-gentoo-r1; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53B3A7CB.8020901@xs4all.nl>
References: <201308061239.27188.hverkuil@xs4all.nl> <2051293.PjTd9YAWz0@avalon> <53B3A7CB.8020901@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Wednesday 02 July 2014 08:33:47 Hans Verkuil wrote:
> For now it is -ENOTIME for me. It's on my TODO list, but there are a number
> of other things I want to finish first.

No worries, I know how it feels. I just wanted to make sure you hadn't missed 
my e-mail.

-- 
Regards,

Laurent Pinchart

