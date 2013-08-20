Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab3HTVP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:15:58 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:55626 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3HTVP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:15:57 -0400
Date: Tue, 20 Aug 2013 16:15:53 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH -mm] docs: Document soft dirty behaviour for freshly
 created memory regions
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References: <20130820153132.GK18673@moon>
In-Reply-To: <20130820153132.GK18673@moon> (from gorcunov@gmail.com on Tue
	Aug 20 10:31:32 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377033353.2737.80@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:31:32 AM, Cyrill Gorcunov wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

With that cc: list, I'll assume you do _not_ want the Documentation  
maintainer paying attention to it.

Rob