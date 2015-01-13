Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbbAMP1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:27:44 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:62819 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbAMP1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:27:42 -0500
Date: Tue, 13 Jan 2015 10:27:38 -0500
From: Tejun Heo <tj@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata_eh_report() unable to handle kernel NULL pointer dereference
Message-ID: <20150113152738.GC2976@htj.dyndns.org>
References: <20150113142509.GA985@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113142509.GA985@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:25:09PM +0900, Sergey Senozhatsky wrote:
> Hi,
> 
> linux-next 20150112
> 
> [  934.572323] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4090800 action 0xe frozen
> [  934.572329] ata2: irq_stat 0x00400040, connection status changed
> [  934.572332] ata2: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  934.572341] BUG: unable to handle kernel NULL pointer dereference at 0000000000000460
> [  934.572346] IP: [<ffffffff812c722c>] ata_eh_report+0x3ad/0x74d

Any chance you can run addr2line on it and map it to the source line?

Thanks.

-- 
tejun
