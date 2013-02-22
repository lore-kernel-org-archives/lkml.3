Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab3BVOo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:44:29 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:54148 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3BVOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:44:26 -0500
Message-ID: <5127841B.2060207@cogentembedded.com>
Date: Fri, 22 Feb 2013 18:43:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rado Vrbovsky <rvrbovsk@redhat.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff <jgarzik@redhat.com>
Subject: Re: [PATCH] ata_piix: Add MODULE_PARM_DESC to prefer_ms_hyperv
References: <774443881.7195405.1361473310424.JavaMail.root@redhat.com>
In-Reply-To: <774443881.7195405.1361473310424.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-02-2013 23:01, Rado Vrbovsky wrote:

> From: Andrew Brownfield <abrownfi@redhat.com>

> In reference to the commit cd006086fa5d91414d8ff9ff2b78fbb593878e3c
> "ata_piix: defer disks to the Hyper-V drivers by default",
> this trivial patch adds a description to prefer_ms_hyperv.

> [rvrbovsk@redhat.com: MODULE_PARM_DESC() string formatting modified]

> Signed-off-by: Andrew Brownfield <abrownfi@redhat.com>

    Note that you can't jus mechanically add Andrew's signoff to the patch, 
you have to ask him to sign it off... I hope you did.

> Signed-off-by: Radomir Vrbovsky <rvrbovsk@redhat.com>

MBR, Sergei

