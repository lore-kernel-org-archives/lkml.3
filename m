Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab3DCNAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:00:41 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35269 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab3DCNAk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Wed, 3 Apr 2013 09:00:40 -0400
Message-Id: <515C444002000078000CA5B5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 03 Apr 2013 14:01:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Chen Gang" <gang.chen@asianux.com>, "William Dauchy" <wdauchy@gmail.com>
Cc: <roger.pau@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers/block/xen-blkback: preq.dev is used
 without initialized
References: <512EC22F.5020404@asianux.com>
 <CAJ75kXZc+GtYi7ULs96G3VkmyzkS5-qe702iXpNenpPj8GF5BQ@mail.gmail.com>
In-Reply-To: <CAJ75kXZc+GtYi7ULs96G3VkmyzkS5-qe702iXpNenpPj8GF5BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.04.13 at 14:56, William Dauchy <wdauchy@gmail.com> wrote:
> On Thu, Feb 28, 2013 at 3:34 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> additional information:
>>   before commit 01c681d4c70d64cb72142a2823f27c4146a02e63, the value printed
>>   here was bogus, as it was the guest provided value from req->u.rw.handle
>>   rather than the actual device.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> Acked-by: Jan Beulich <JBeulich@suse.com>
> 
> Sorry I'm a bit late but since since 01c681d is in stable, I guess
> a72d900 (xen/xen-blkback: preq.dev is used without initialized)
> could be added in stable as well.
> Am I wrong? otherwise I'm ok to do the request.

Iirc we requested the earlier commit to be removed from stable
trees, and I think Greg also did so.

Jan

