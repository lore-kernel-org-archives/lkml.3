Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3KNONv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:13:51 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33272 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3KNONn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:13:43 -0500
Message-ID: <5284DA98.1060402@gmail.com>
Date: Thu, 14 Nov 2013 09:13:44 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>,
        Pavel Roskin <proski@gnu.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: Uncompressed kernel doesn't build on x86_64
References: <20131113113418.167b8ffd@IRBT4585> <20131114083247.GB9687@ab42.lan>
In-Reply-To: <20131114083247.GB9687@ab42.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-11-14 03:32, Christian Ruppert wrote:
> 2. A patch to enable uncompressed x86 kernels. As stated above, I don't
>    think this makes a lot of sense in itself but it might serve as an
>    example for people working on other platforms with self-extracting
>    kernels and the nozip not-decompression algorithm might be useful on
>    those platforms as well. I only had a single x86-64 machine available
>    to test this, however, so some more testing might be required.

I disagree with the argument that an uncompressed x86 kernel doesn't
make sense, If you have a very fast boot device, then it is fully
conceivable that an uncompressed kernel could boot faster than a
compressed one.  I have seen a very large number of systems where the
LZO compression boots at least twice as fast as gzip or bz2 (because the
disks are fast enough that a few megabytes of size difference make much
less of an impact than a slow decompressor).
