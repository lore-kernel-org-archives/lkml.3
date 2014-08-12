Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaHLGIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:08:07 -0400
Received: from mta-out1.inet.fi ([62.71.2.193]:35647 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHLGIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:08:05 -0400
Date: Tue, 12 Aug 2014 09:07:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Oren Twaig <oren@scalemp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: x86: vmalloc and THP
Message-ID: <20140812060745.GA7987@node.dhcp.inet.fi>
References: <53E99F86.5020100@scalemp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E99F86.5020100@scalemp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 08:00:54AM +0300, Oren Twaig wrote:
> <html style="direction: ltr;">

plain/text, please.

>Hello,
>
>Does memory allocated using vmalloc() will be mapped using huge
>pages either directly or later by THP ? 

No. It's neither aligned properly, nor physically contiguous.

>If not, is there any fast way to change this behavior ? Maybe by
>changing the granularity/alignment of such allocations to allow such
>mapping ?

What's the point to use vmalloc() in this case?

-- 
 Kirill A. Shutemov
