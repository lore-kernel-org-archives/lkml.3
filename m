Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3EPUfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:35:38 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:58243 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373Ab3EPUfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:35:33 -0400
Message-ID: <1368736525.1350.214.camel@x61.thuisdomein>
Subject: Re: [PATCH] stallion: final cleanup
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 16 May 2013 22:35:25 +0200
In-Reply-To: <201303211429.29502.arnd@arndb.de>
References: <1363871896.1390.138.camel@x61.thuisdomein>
	 <201303211429.29502.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2013 20:35:26.0213 (UTC) FILETIME=[E59ABB50:01CE5274]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 14:29 +0000, Arnd Bergmann wrote:
> On Thursday 21 March 2013, Paul Bolle wrote:
> > Support for the Stallion multiport serial drivers was removed in v3.1.
> > Clean up their last references in the tree: mainly an outdated Kconfig
> > entry and unneeded documentation.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

I don't think this patch is queued somewhere. Greg? Arnd?


Paul Bolle

