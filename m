Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab3AYQw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:52:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:44336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3AYQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:52:55 -0500
Message-ID: <5102B8A6.3090200@infradead.org>
Date: Fri, 25 Jan 2013 08:53:58 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 25 (kvm)
References: <20130125162606.edff84fcf6f62ed2b7c4d719@canb.auug.org.au>
In-Reply-To: <20130125162606.edff84fcf6f62ed2b7c4d719@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/13 21:26, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130124:
> 


Seeing lots of this error on i386:

arch/x86/kvm/emulate.c:1016: Error: unsupported for `push'



-- 
~Randy
