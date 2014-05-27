Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaE0HLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:11:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43605 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaE0HLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:11:54 -0400
Message-ID: <53843AAB.8070404@zytor.com>
Date: Tue, 27 May 2014 00:11:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: hnnnet48@gmail.com, gregkh@suse.de, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] This is my first commit
References: <1401173061-6500-1-git-send-email-hnnnet48@gmail.com>
In-Reply-To: <1401173061-6500-1-git-send-email-hnnnet48@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

I suggest reading the file Documentation/SubmittingPatches for general
guidance as how to submit patches.

> +#define MAJOR_NUM              100
> +#define MAJOR_MIN              0

Fixed device numbers need to be allocated from <device@lanana.org>
(currently managed by Alan Cox).  However, this should probably be a
misc device, or better yet, an input device.

	-hpa

