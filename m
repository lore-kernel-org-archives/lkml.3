Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaLaSzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 13:55:21 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36144 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLaSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 13:55:20 -0500
Date: Wed, 31 Dec 2014 10:55:17 -0800
From: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: lustre: linux-prim.c: fix sparse warnings
 about static declaration
Message-ID: <20141231185517.GA899@fedora.localdomain>
References: <20141231084833.GA6643@fedora.localdomain>
 <20141231104029.GA25819@t400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141231104029.GA25819@t400>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 11:40:29AM +0100, Konrad Zapalowicz wrote:
> This lines are way too long. You should break the commit message line
> around 72nd column so that it looks nice when emailed.
> 
> You can also omit the filename from the topic line as this is already in
> the diff.

Thanks for the feedback; I'll send an updated patch that fixes these issues.

Serguey
