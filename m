Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966896AbaFTK7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:59:15 -0400
Received: from fep20.mx.upcmail.net ([62.179.121.40]:37301 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965650AbaFTK7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:59:11 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <53A413FB.9050602@odi.ch>
Date: Fri, 20 Jun 2014 12:59:07 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG at mm/memory.c
References: <53A3102E.2030602@odi.ch> <20140619165205.GA26761@node.dhcp.inet.fi>
In-Reply-To: <20140619165205.GA26761@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 06:52 PM, Kirill A. Shutemov wrote:
> http://marc.info/?l=linux-kernel&m=140319579508104&w=2

Yes, those symptoms look very familiar. The patch should really go in stable 3.15.y.

Thanks.

Ortwin
