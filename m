Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936204Ab3DHOGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:06:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935950Ab3DHOFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:05:51 -0400
Message-ID: <5162CEC1.5070400@suse.cz>
Date: Mon, 08 Apr 2013 16:05:53 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] buildtar: Add ARCH to the archive name
References: <1362557147-14393-1-git-send-email-bp@alien8.de> <20130307110659.GC22602@8bytes.org> <20130307110910.GA5834@pd.tnic>
In-Reply-To: <20130307110910.GA5834@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.3.2013 12:09, Borislav Petkov wrote:
> On Thu, Mar 07, 2013 at 12:06:59PM +0100, Joerg Roedel wrote:
>> Good idea, but I already hear people yelling about their scripts that
>> break with this change :)
> 
> They better fix them then. :-)

OK, I applied the patch to kbuild.git#misc. Let's see how many people
protest...

Michal

