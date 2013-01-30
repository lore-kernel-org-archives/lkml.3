Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3A3Ta0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:30:26 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50726 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab3A3TaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:30:22 -0500
Date: Wed, 30 Jan 2013 14:21:47 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-01-24
Message-ID: <20130130192147.GC2167@tuxdriver.com>
References: <20130124031052.GE1632@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124031052.GE1632@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:10:52AM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> This is my first pull request to 3.9. The biggest changes here are from Johan
> Hedberg who made a lot of fixes in the Management interface. The issues arose
> due to a new test tool we wrote and the usage of the Management interface as
> default in BlueZ 5. The rest of the patches are more clean ups and small
> fixes.
> 
> Please pull! Thanks!
> 
> 
> 	Gustavo
> ---
> The following changes since commit e7f767a7d9f809c494bfffffeda2bbdbfec110b4:
> 
>   mwifiex: use map/unmap APIs in TX and RX to reduce memcpy (2013-01-07 15:18:30 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next for-upstream
> 
> for you to fetch changes up to 9b008c0457e583e10e62d1215bed6ab26ee54906:
> 
>   Bluetooth: Add support for reading LE supported states (2013-01-23 02:09:16 -0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
