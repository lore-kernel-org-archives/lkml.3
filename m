Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbaGDGM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:12:58 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:42742 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaGDGM5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 4 Jul 2014 02:12:57 -0400
Message-Id: <53B662080200007800020831@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Fri, 04 Jul 2014 07:12:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Greg KH" <gregkh@linuxfoundation.org>
Cc: <stable@kernel.org>, "Don A. Bailey" <donb@securitymouse.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lz4: add overrun checks to
 lz4_uncompress_unknownoutputsize()
References: <20140703231103.GA4081@kroah.com>
In-Reply-To: <20140703231103.GA4081@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.07.14 at 01:11, <gregkh@linuxfoundation.org> wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Jan points out that I forgot to make the needed fixes to the
> lz4_uncompress_unknownoutputsize() function to mirror the changes done
> in lz4_decompress() with regards to potential pointer overflows.

Except that meanwhile Don agreed with my statement that neither
this nor the two earlier patches really fix the issue. So rather than
pushing this into 3.16 and stable trees, I wonder whether the two
earlier ones shouldn't be reverted and then a clean and correct
fix be applied.

Jan

