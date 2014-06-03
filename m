Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFCKTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:19:33 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:35888 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaFCKTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:19:31 -0400
Date: Tue, 3 Jun 2014 14:19:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH -next] fs: pipe -- Take into account requested @len in
 iter_file_splice_write
Message-ID: <20140603101928.GD17659@moon>
References: <20140530203332.GA23463@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530203332.GA23463@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 12:33:32AM +0400, Cyrill Gorcunov wrote:
> Currently iter_file_splice_write pushes into the output IOVs as much
> as it can, so that if one previously pushed into pipe 8K of data and
> then try to fetch 4K -- he get the complete 8K instead.
> 
> Lest count how many bytes were requested by a caller and
> stop looping once request is complete.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Ping?
