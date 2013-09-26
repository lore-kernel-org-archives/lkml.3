Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3IZSAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:00:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35911 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3IZSAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:00:12 -0400
Date: Thu, 26 Sep 2013 13:47:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-09-23
Message-ID: <20130926174750.GB1931@tuxdriver.com>
References: <20130923210049.GG18215@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923210049.GG18215@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:00:49PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> First Bluetooth fixes to 3.12, it includes:
> 
> * 3 patches to add device id for 3 new hardwares.
> 
> * 2 patches from Johan to fix the rfkill behaviour during setup stage
> 
> * a small clean up in the rfcomm TTY code that fixes a potential racy
> condition (by Gianluca Anzolin)
> 
> * 2 fixes to proper set encryption key size and security level in the
> peripheral role of Bluetooth LE devices. (by Andre Guedes)
> 
> * a fix for dealing devices where pairing is not necessary, we were keeping
> the Bluetooth ACL connection alive for too much time. (by Syam Sidhardhan)
> 
> Please pull or let me know of any problems! Thanks!
> 
> 
> 	Gustavo
> 
> ---
> The following changes since commit f4e1a4d3ecbb9e42bdf8e7869ee8a4ebfa27fb20:
> 
>   rt2800: change initialization sequence to fix system freeze (2013-09-09 14:44:34 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to 5bcecf325378218a8e248bb6bcae96ec7362f8ef:
> 
>   Bluetooth: btusb: Add support for Belkin F8065bf (2013-09-23 17:44:25 -0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
