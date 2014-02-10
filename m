Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBJA6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:58:43 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:56771 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbaBJA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:58:42 -0500
Message-ID: <1391993920.14955.5.camel@x220>
Subject: Re: Remove orphan kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 01:58:40 +0100
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Feb 2014 00:58:41.0088 (UTC) FILETIME=[3D342400:01CF25FB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> [PATCH 14/28] Remove MACH_SMDKC210

Did this one make it to lkml? 

Anyhow, you should also check MACH_SMDKV310. And then have a look at
https://lkml.org/lkml/2013/7/14/27 , in which Mark Brown (added in CC)
and I spent some time not understanding each other (at least, that was
my impression).


Paul Bolle

