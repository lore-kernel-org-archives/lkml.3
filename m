Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaAMMeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:34:31 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:40440 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaAMMe2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 13 Jan 2014 07:34:28 -0500
Message-Id: <52D3EB5F02000078001130B5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 13 Jan 2014 12:34:23 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check
 from blkfront_setup_discard
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de>
 <52D3DAEE0200007800112FD4@nat28.tlf.novell.com>
 <20140113120131.GA15623@aepfle.de>
In-Reply-To: <20140113120131.GA15623@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.01.14 at 13:01, Olaf Hering <olaf@aepfle.de> wrote:
> On Mon, Jan 13, Jan Beulich wrote:
> 
>> You can't do this in one go - the first two and the last one may be
>> set independently (and are independent in their meaning), and
>> hence need to be queried independently (xenbus_gather() fails
>> on the first absent value).
> 
> Yes, thats the purpose. Since the properties are required its an all or
> nothing thing. If they are truly optional then blkif.h should be updated
> to say that.

They _are_ optional.

Jan

