Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3LSQLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:11:04 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:41181 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab3LSQLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:11:01 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 11:11:00 EST
Date: Thu, 19 Dec 2013 17:04:45 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Message-ID: <20131219170445.42b50a5b@linux.lan.towertech.it>
In-Reply-To: <52B309EB.90300@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
	<52B309EB.90300@zytor.com>
Organization: Tower Technologies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 06:59:55 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> EFI time is something we used to support and ripped out, because it
> doesn't work well, *at all*.
> 
> I am hyper-skeptical to reintroducing them, and *definitely* will veto
> reintroducing them on a system which has PNP0B0x devices present.

 Definitely agree.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

