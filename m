Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216Ab3FSWCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:02:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42066 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934979Ab3FSWCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:02:34 -0400
Message-ID: <51C22A6B.3090009@zytor.com>
Date: Wed, 19 Jun 2013 15:02:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [x86] only print out DR registers if they are not power-on defaults.
References: <20130618041132.GA23492@redhat.com> <20130618084356.GA13123@pd.tnic> <20130618140730.GA1313@redhat.com> <20130618155919.GC13123@pd.tnic> <51C225D9.8070100@zytor.com> <20130619215233.GU28300@pd.tnic>
In-Reply-To: <20130619215233.GU28300@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 02:52 PM, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 02:42:49PM -0700, H. Peter Anvin wrote:
>> There is serious confusion with regards to DR6 about the bits which
>> are *fixed* (forced to 1) and the ones which are *reserved* (should
>> always have a fixed value.)
>>
>> There are some bits in DR6 which are used by hardware probes.
> 
> Haha, I knew it! HW guys don't care about the architectural documents.
> 
> Maybe DR6 should probably be dropped altogether from the check before
> exiting __show_regs early?
> 

Uhm... I think you're missing the point of architectural documents.

The architectural documents describe the contract between hardware and
software.  It doesn't mean that hardware can't go beyond it... it is in
fact the norm.  The architectural documentation states what software may
rely on and within what bounds it can assume safe behavior to be
compatible both now and with any future extensions.

	-hpa

