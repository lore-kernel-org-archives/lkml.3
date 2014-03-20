Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009AbaCTW0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:26:55 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34796 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbaCTW0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:26:53 -0400
Message-ID: <532B6AE9.5050103@ahsoftware.de>
Date: Thu, 20 Mar 2014 23:25:45 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>
Subject: Re: [PATCH v2] initramfs: print error and shell out for unsupported
 content
References: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com> <1395352845-7435-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1395352845-7435-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.03.2014 23:00, schrieb Alexander Holler:
> The initramfs generation is broken for file and directory names which contain
> colons or spaces. Print an error and don't try to continue.

I will not send a v3, but I think this is a candidate for the stable 
kernels too, as the problem might drive people crazy. Therefor;

Cc: <stable@vger.kernel.org>

Regards,

Alexander Holler
