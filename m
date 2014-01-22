Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaAVL4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:56:34 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:51744 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaAVL4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:56:33 -0500
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
In-Reply-To: <20140106091124.32dc1057@notabene.brown>
References: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
 <20130422083549.7c1cff84@notabene.brown> <CACaajQtt1t-tdCrW6eCgx0_0WxTNR1buV6H2iEj_gWzrV3JZfA@mail.gmail.com>
 <20140106091124.32dc1057@notabene.brown>
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Wed, 22 Jan 2014 15:56:16 +0400
X-Google-Sender-Auth: vMmxSRbitjiaeqc-6MpPGvObuSY
Message-ID: <CACaajQu25L6pRy=rc90MqG0z+Q1UhiRSQJ7-NhCbUkkUgAN95A@mail.gmail.com>
Subject: Re: mdadm raid1 regression
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/6 NeilBrown <neilb@suse.de>:
> The value given to --data-offset is assumed to be kilobytes unless it has a
> suffix: 'M' for megabytes, 's' for sectors.
>
> The value reported by 'mdadm -D' is (as it says) in sectors.
> 1024 kilobytes  is 2048 sectors.
> If you want to specify sectors, add an 's' suffix.


Thanks, Neil. Sorry for delay. I'm test and all works fine.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
