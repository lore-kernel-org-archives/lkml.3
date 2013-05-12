Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3ELQxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:53:43 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57978 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab3ELQxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:53:42 -0400
Date: Sun, 12 May 2013 11:53:37 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: high-speed disk I/O is CPU-bound?
To: David Oostdyk <daveo@ll.mit.edu>
Cc: linux-kernel@vger.kernel.org
References: <518CFE7C.9080708@ll.mit.edu>
In-Reply-To: <518CFE7C.9080708@ll.mit.edu> (from daveo@ll.mit.edu on Fri May
	10 09:04:44 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1368377617.18069.228@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 09:04:44 AM, David Oostdyk wrote:
> Hello,
> 
> I have a few relatively high-end systems with hardware RAIDs which  
> are being used for recording systems, and I'm trying to get a better  
> understanding of contiguous write performance.
...
> The question is, is it possible that high-speed I/O to these hardware  
> RAIDs could
> actually be CPU-bound above ~1400MB/sec?

In some setups your processor is calculating CRCs for the data. It's a  
fairly cheap operation, but a cheap operation on gigabytes of data can  
still saturate your memory bus.

Rob