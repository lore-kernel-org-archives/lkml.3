Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab3BZRg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:36:58 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1764 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3BZRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:36:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: [PATCH v6 0/9] Driver for Si476x series of chips
Date: Tue, 26 Feb 2013 18:36:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: mchehab@redhat.com, sameo@linux.intel.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1361896295-26138-1-git-send-email-andrew.smirnov@gmail.com>
In-Reply-To: <1361896295-26138-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302261836.39517.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue February 26 2013 17:31:26 Andrey Smirnov wrote:
> This is a fourth version of the patchset originaly posted here:
> https://lkml.org/lkml/2012/9/13/590
> 
> Second version of the patch was posted here:
> https://lkml.org/lkml/2012/10/5/598
> 
> Third version of the patch was posted here:
> https://lkml.org/lkml/2012/10/23/510
> 
> Fourth version of the patch was posted here:
> https://lkml.org/lkml/2013/2/18/572
> 
> Fifth version of the patch was posted here:
> https://lkml.org/lkml/2013/2/26/45
> 
> To save everyone's time I'll repost the original description of it:
> 
> This patchset contains a driver for a Silicon Laboratories 476x series
> of radio tuners. The driver itself is implemented as an MFD devices
> comprised of three parts: 
>  1. Core device that provides all the other devices with basic
> functionality and locking scheme.
>  2. Radio device that translates between V4L2 subsystem requests into
> Core device commands.
>  3. Codec device that does similar to the earlier described task, but
> for ALSA SoC subsystem.
> 
> v6 of this driver has following changes:
>    - Minor corrections

For this patch series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thank you very much for your work on this!

Regards,

	Hans
