Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbbA2BOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:14:07 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:65036 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbbA2BNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:13:33 -0500
Message-ID: <1422480916.3621.53.camel@x220>
Subject: Re: cxgb4:  CONFIG_CXGB4_DCB?
From: Paul Bolle <pebolle@tiscali.nl>
To: Hariprasad S <hariprasad@chelsio.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 22:35:16 +0100
In-Reply-To: <1422431914.5666.7.camel@x220>
References: <1422431914.5666.7.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2015 21:35:16.0605 (UTC) FILETIME=[4E9592D0:01D03B42]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend because netdev and linux-kernel were down the first time.]

On Wed, 2015-01-28 at 08:58 +0100, Paul Bolle wrote:
> Your commit dc9daab226aa ("cxgb4: Added support in debugfs to dump
> sge_qinfo") is included in today's linux-next (ie, next-20150128). I
> noticed because a script I use to check linux-next spotted a problem
> with it.
> 
> It added a preprocessor check for CONFIG_CXGB4_DCB. There's no Kconfig
> symbol CXGB4_DCB. I guess a check for CONFIG_CHELSIO_T4_DCB was actually
> intended.
> 
> Thanks,
> 
> 
> Paul Bolle


