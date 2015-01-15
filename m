Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbbAOQv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:51:27 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55416 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbbAOQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:51:25 -0500
Message-ID: <54B7F008.9060100@collabora.com>
Date: Thu, 15 Jan 2015 11:51:20 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?windows-1252?Q?Fr=E9d=E9ric_Sureau?= 
	<frederic.sureau@vodalys.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kamil Debski <k.debski@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: Re: [RFC PATCH] [media] coda: Use S_PARM to set nominal framerate
 for h.264 encoder
References: <1419264000-11761-1-git-send-email-p.zabel@pengutronix.de> <54B7E978.5050505@vodalys.com>
In-Reply-To: <54B7E978.5050505@vodalys.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 2015-01-15 11:23, Frédéric Sureau a écrit :
> Maybe a->parm.output.capability should be set to 
> |V4L2_CAP_TIMEPERFRAME| here.
> I think it is required by GStreamer V4L2 plugin.
Looking at this, I think output device is indeed the right place to set 
this, and the capability should indeed be updated. Now for the GStreamer 
side, it will need patching. At the moment, this cap is only checked for 
capture device. It's not a major change to enabled that for output 
device with that capability.

cheers,
Nicolas
