Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbbAMRsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:48:42 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44241 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbbAMRsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:48:40 -0500
Date: Tue, 13 Jan 2015 20:48:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: geert@linux-m68k.org, arnd@arndb.de, rdunlap@infradead.org,
        akpm@linux-foundation.org
Subject: Re: + linux-typesh-always-use-unsigned-long-for-pgoff_t.patch added
 to -mm tree
Message-ID: <20150113174842.GA2174@p183.telecom.by>
References: <54b431cc.+CIo9/mn2KjN+BdH%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b431cc.+CIo9/mn2KjN+BdH%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:42:52PM -0800, akpm@linux-foundation.org wrote:
> -#ifndef pgoff_t
>  #define pgoff_t unsigned long
> -#endif

Should be typedef'ed.

	Alexey
