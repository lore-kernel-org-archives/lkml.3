Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3GPLeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:34:04 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41111 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754684Ab3GPLeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:34:02 -0400
Message-ID: <1373974436.2148.47.camel@dabdike>
Subject: Re: [PATCH 1/3] arcmsr: Modify maximum outstanding command
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?UTF-8?Q?=E9=BB=83=E6=B8=85=E9=9A=86?= <ching2048@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        billion.wu@areca.com.tw
Date: Tue, 16 Jul 2013 15:33:56 +0400
In-Reply-To: <17ED0DB5E21E4C1EB3CBEDA7F46F7D97@chingDT>
References: <17ED0DB5E21E4C1EB3CBEDA7F46F7D97@chingDT>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 18:22 +0800, 黃清隆 wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Modify maximum outstanding command value, notify auto request sense, reassign ARC12x4 series to SATA adapter.
> Signed-off-by:Ching<ching2048@areca.com.tw>
> ---

This patch needs to make it to the SCSI mailing list and it didn't.  You
can easily check this yourself by either subscribing to the reflector or
looking at some of the archivers like marc:

http://marc.info/?l=linux-scsi

The reason it got dropped is probably because you have a text/html
attachment.  vger accepts text/plain only.

James


