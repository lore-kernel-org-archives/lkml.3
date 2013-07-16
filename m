Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab3GPLsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:48:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:63719 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3GPLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:48:17 -0400
Message-ID: <51E53300.6010000@cogentembedded.com>
Date: Tue, 16 Jul 2013 15:48:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: unlisted-recipients:"; Alexander Gordeev" <agordeev@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;Alexander Gordeev <agordeev@redhat.com>
					     ^-missing end of address
Subject: Re: [PATCH] AHCI: fix Null pointer dereference in achi_host_active()
References: <1373951920-31699-1-git-send-email-xtfeng@gmail.com>
In-Reply-To: <1373951920-31699-1-git-send-email-xtfeng@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-07-2013 9:18, Xiaotian Feng wrote:

> commit b29900e6 introuded a regression, which resulted Null pointer

    Please also specify that commit's summary in parens.

> dereference for achi host with dummy ports. For ahci ports, when the
> port is dummy port, its private_data will be NULL, as ata_dummy_port_ops
> doesn't support ->port_start.

> Reported-and-tested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
> Cc: Alexander Gordeev <agordeev@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

MBR, Sergei


