Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3KEVAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:00:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34529 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3KEVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:00:28 -0500
Date: Tue, 5 Nov 2013 15:58:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-10-30
Message-ID: <20131105205841.GI8264@tuxdriver.com>
References: <20131030193842.GA2271@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030193842.GA2271@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 05:38:42PM -0200, Gustavo Padovan wrote:
> Hi John,
> 
> A last fix to the 3.12. I ended forgetting to send it before, I hope we can
> still make the way to 3.12. It is a revert and it fixes an issue with bluetooth
> suspend/hibernate that had many bug reports. Please pull or let me know of any
> problems. Thanks!
> 
> 	Gustavo
> --
> The following changes since commit c7515d2365a6b8a018950198ebe1f5be793cd4bb:
> 
>   brcmsmac: call bcma_core_pci_power_save() from non-atomic context (2013-09-26 14:02:34 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to b1a8014471b01dd862de9f91bbbff1296afac42d:
> 
>   Bluetooth: revert: "Bluetooth: Add missing reset_resume dev_pm_ops" (2013-10-02 16:01:49 -0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
