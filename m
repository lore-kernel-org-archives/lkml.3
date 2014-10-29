Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaJ2Crr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:47:47 -0400
Received: from rush.cubic.ch ([176.9.78.115]:37618 "EHLO mail2.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaJ2Crq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:47:46 -0400
Message-ID: <5450554B.1080906@decentral.ch>
Date: Wed, 29 Oct 2014 03:47:39 +0100
From: Tim Tassonis <stuff@decentral.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: overlayfs: "filesystem of lowerdir is not supported" on cdrom
References: <544FDC1C.9040908@decentral.ch> <20141028211313.GB7996@ZenIV.linux.org.uk> <20141028225428.GC7996@ZenIV.linux.org.uk>
In-Reply-To: <20141028225428.GC7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 11:54 PM, Al Viro wrote:
> On Tue, Oct 28, 2014 at 09:13:13PM +0000, Al Viro wrote:
> 
>>
>> We probably ought to split the normal (case-sensitive, no joliet shite) case
>> out and leave it with NULL ->s_d_op, but that'll need to be done carefully,
>> or isofs_cmp() will blow up on us.
> 
> See if vfs.git#for-linus works for you.
> 

Yes, works for me! Could mount the overlayfs, remove a file, add a file
and modify a file. Not the definive stress-test I guess, but it's a start...

Took only the following two commits:

f643ff550afbc82a2bc7026f4a6d64427e4fbc9

5b71ecfa78271d5c576f17156ed8a53981c1ecb

Kind regards
Tim

