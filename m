Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3GaL1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:27:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19785 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3GaL1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:27:24 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51F8DDEB.603@citrix.com>
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <51F8DDEB.603@citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Xen-devel] [PATCH RFC 0/4] xen-block: prevent blkfront for hoarding grants
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 31 Jul 2013 07:27:15 -0400
To: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>,
        xen-devel@lists.xen.org
CC: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@citrix.com>
Message-ID: <604ab238-8a85-43af-bd97-2977fdfe1bbb@email.android.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Roger Pau Monné" <roger.pau@citrix.com> wrote:
>On 08/07/13 15:03, Roger Pau Monne wrote:
>> The following patches prevent blkfront from hoarding all grants in
>the 
>> system by allowing blkfront to request blkback to unmap certain
>grants 
>> so they can be freed by blkfront. This is done periodically by 
>> blkfront, unmapping a certain amount of unused persistent grants.
>> 
>> This series also includes a bug fix for the grant table free callback
>
>> implementation.
>
>Hello,
>
>IMHO I think 1 should go in (at the end it's a bugfix) and backported
>to
>stable. 2 and 4 (second version) can probably also go in?
>
>Roger.

Can you repost the patch series please with some of the comments addressed in the commit description  please.  Note that the patch series It says RFC on them :-) 
