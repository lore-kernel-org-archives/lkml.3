Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3EWQOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:14:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43114 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3EWQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:14:21 -0400
Message-ID: <519E4029.5090101@infradead.org>
Date: Thu, 23 May 2013 09:13:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Platform Driver <platform-driver-x86@vger.kernel.org>
Subject: Re: linux-next: Tree for May 23 (asus-wmi)
References: <20130523154924.db69d92fe88f9d22a87e822d@canb.auug.org.au>
In-Reply-To: <20130523154924.db69d92fe88f9d22a87e822d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/13 22:49, Stephen Rothwell wrote:
> Hi all,
> 
> There will be no linux-next release tomorrow.
> 
> Changes since 20130522:
> 


when CONFIG_ACPI_VIDEO=m and ASUS_WMI=y:

drivers/built-in.o: In function `asus_wmi_add':
asus-wmi.c:(.text+0x252514): undefined reference to `acpi_video_unregister'


-- 
~Randy
