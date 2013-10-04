Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab3JDFB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:01:29 -0400
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:59105 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3JDFB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:01:28 -0400
Message-ID: <1380862901.4265.33.camel@porter.coelho.fi>
Subject: Re: [GIT PULL] firmware: wl1251 firmware binary
From: Luca Coelho <luca@coelho.fi>
To: balbi@ti.com
Cc: dwmw2@infradead.org, ben@decadent.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, Pavel Machek <pavel@denx.de>
Date: Fri, 04 Oct 2013 08:01:41 +0300
In-Reply-To: <20131002125535.GL1476@radagast>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
	 <1380107096.4503.8.camel@porter.coelho.fi>
	 <1380107278.4503.9.camel@porter.coelho.fi>
	 <20130925132359.GE10746@radagast>
	 <1380116535.4503.19.camel@porter.coelho.fi>
	 <20130925135943.GI10746@radagast> <20131002125535.GL1476@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, 2013-10-02 at 07:55 -0500, Felipe Balbi wrote:
> Hi,
> 
> here's a pull request for wl4 firmware. I'll send a patch for wl1251
> driver updating firmware load path.
> 
> The following changes since commit b8ac7c7e27dcd13fa3c843aaf62457e9c57ea4db:
> 
>   linux-firmware: Add Brocade FC/FCOE Adapter firmware files (2013-09-30 04:53:32 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware.git wilink4
> 
> for you to fetch changes up to d726804dbc8dad88587b6be17716714cd91ed86c:
> 
>   ti-connectivity: add wl1251 firmware and license (2013-10-02 06:55:39 -0500)
> 
> ----------------------------------------------------------------
> Felipe Balbi (1):
>       ti-connectivity: add wl1251 firmware and license
> 
>  LICENCE.wl1251                 |  59 +++++++++++++++++++++++++++++++++++++++++
>  WHENCE                         |  18 +++++++++++++
>  ti-connectivity/wl1251-fw.bin  | Bin 0 -> 194180 bytes
>  ti-connectivity/wl1251-nvs.bin | Bin 0 -> 752 bytes
>  4 files changed, 77 insertions(+)
>  create mode 100644 LICENCE.wl1251
>  create mode 100644 ti-connectivity/wl1251-fw.bin
>  create mode 100644 ti-connectivity/wl1251-nvs.bin

Since you didn't send v2 of the patch, you could have used the -p option
with git request-pull so we could see the changes you made here...

--
Cheers,
Luca.


