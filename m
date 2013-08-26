Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3HZKSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:18:45 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60242 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244Ab3HZKSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:18:43 -0400
Message-ID: <1377512318.20958.5.camel@dabdike>
Subject: Re: [PATCH 1/3] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?UTF-8?Q?=E9=BB=83=E6=B8=85=E9=9A=86?= <ching2048@areca.com.tw>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, billion@areca.com.tw
Date: Mon, 26 Aug 2013 14:18:38 +0400
In-Reply-To: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
References: <7A2818CC441F4BCE96D3B1E70CC3D76B@chingDT>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-26 at 12:14 +0800, 黃清隆 wrote:
>  From: Ching <ching2048@areca.com.tw>
> 
> Support Areca new SATA Raid adapter ARC1214/1224/1264/1284.
> Modify maximum outstanding command number, notify command complete with auto
> request sense
> Signed-off-by: Ching  <ching2048@areca.com.tw>

Checkpatch really doesn't like this:

total: 1 errors, 173 warnings, 7131 lines checked

I fixed up the error and the few relevant warnings.  I don't really care
about the lines over 80 characters.  However, if you're going to have
long lines, don't split strings (another checkpatch complaint).  I'd
also like to see the spurious braces removed in a later patch, please.
The prinks without a KERN_ also need fixing.

James


