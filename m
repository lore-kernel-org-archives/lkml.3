Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423033Ab3CVU0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423000Ab3CVU0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:26:42 -0400
Date: Fri, 22 Mar 2013 16:26:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH] integrity: Use a new type for asymmetric signature
Message-ID: <20130322202635.GH4544@redhat.com>
References: <20130314182815.GB24238@redhat.com>
 <CALLzPKZgSjtodeikffsRyZrq5eS92ziLm3NdjWmD878xL_kFVw@mail.gmail.com>
 <20130314203028.GE24238@redhat.com>
 <20130314203703.GF24238@redhat.com>
 <CALLzPKb646eXYCLrgtuNFYx_Y6dWdwNWZM1whJPR1wZBxbVY6w@mail.gmail.com>
 <20130315154151.GA3887@redhat.com>
 <CALLzPKa+7tmpnKt-b_g7p=pdWqutNT=71DbJSmY04TqVRdXrQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKa+7tmpnKt-b_g7p=pdWqutNT=71DbJSmY04TqVRdXrQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 09:57:57AM +0200, Kasatkin, Dmitry wrote:
> On Fri, Mar 15, 2013 at 5:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Mar 14, 2013 at 11:08:45PM +0200, Kasatkin, Dmitry wrote:
> >> On Thu, Mar 14, 2013 at 10:37 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Thu, Mar 14, 2013 at 04:30:28PM -0400, Vivek Goyal wrote:
> >> >
> >> > [..]
> >> >> I thought explicitly using signature format is more intutive. Exporting
> >> >> signature version is not. I personally associate versioning with minor
> >> >> changes like addition of some fields etc.
> >> >
> >> > For instance, you might want to add some fields to  signature_v2_hdr down
> >> > the line. I think even after that change, it still remains "asymmetric
> >> > signature" just that structure size changes and there is additional
> >> > info. If there is versioning info assciated with signature type
> >> > ASYMMETRIC, we could simple bump it to 1.1 or whatever and keep the
> >> > version detail internal to ima/integrity subsystem.
> >> >
> >>
> >> Yes, it will make some things cleaner.
> >
> > So do you agree that every new signature format should have a new entry
> > and we can introduce new signature type for asymmetric signature.
> >
> 
> Hi Vivek,
> 
> I was/am a bit busy with responding.
> I will do it asap.

Hi Dmitry,

Sure. Only thing to keep in mind is that if you want to change it, we
better do it in 3.9. Otherwise changing it in 3.10 will be messy.

Thanks
Vivek
