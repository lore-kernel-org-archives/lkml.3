Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab3CDWPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:15:39 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38500 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3CDWPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:15:35 -0500
Message-ID: <51351D04.4010009@pobox.com>
Date: Mon, 04 Mar 2013 17:15:32 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rado Vrbovsky <rvrbovsk@redhat.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff <jgarzik@redhat.com>
Subject: Re: [PATCH] ata_piix: Add MODULE_PARM_DESC to prefer_ms_hyperv
References: <774443881.7195405.1361473310424.JavaMail.root@redhat.com>
In-Reply-To: <774443881.7195405.1361473310424.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 02:01 PM, Rado Vrbovsky wrote:
> From: Andrew Brownfield <abrownfi@redhat.com>
>
> In reference to the commit cd006086fa5d91414d8ff9ff2b78fbb593878e3c
> "ata_piix: defer disks to the Hyper-V drivers by default",
> this trivial patch adds a description to prefer_ms_hyperv.
>
> [rvrbovsk@redhat.com: MODULE_PARM_DESC() string formatting modified]
>
> Signed-off-by: Andrew Brownfield <abrownfi@redhat.com>
> Signed-off-by: Radomir Vrbovsky <rvrbovsk@redhat.com>
>
> ---
>   drivers/ata/ata_piix.c | 4 ++++
>   1 file changed, 4 insertions(+)

applied [manually]



