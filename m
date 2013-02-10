Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3BJXbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:31:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab3BJXbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:31:02 -0500
Message-ID: <51182DAB.1030708@redhat.com>
Date: Mon, 11 Feb 2013 00:30:51 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
References: <cover.1360528614.git.dborkman@redhat.com>  <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com> <1360538650.2028.2.camel@joe-AO722>
In-Reply-To: <1360538650.2028.2.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 12:24 AM, Joe Perches wrote:
> On Sun, 2013-02-10 at 23:00 +0100, Daniel Borkmann wrote:
>> add memcmp_nta ({n}o {t}iming {a}ttacks)
>
> Why should this be in the kernel?

As the commit message already says, so that current or future (e.g.) network
protocol code or modules can make use of this when dealing with cryptographic
hash comparisons.
