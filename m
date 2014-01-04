Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaADVY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 16:24:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:6107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbaADVYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 16:24:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,604,1384329600"; 
   d="scan'208";a="453695748"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: David Howells <dhowells@redhat.com>, Paul Bolle <pebolle@tiscali.nl>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 7/7] Fix uninitialised variable warning in
 mei-amt-version.c
Thread-Topic: [PATCH 7/7] Fix uninitialised variable warning in
 mei-amt-version.c
Thread-Index: AQHPCJ4GLDSEu4hgLEuZyrmpCW5oGZpzDWQAgAADKwCAAgDYYA==
Date: Sat, 4 Jan 2014 21:24:21 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF3BC0D@HASMSX106.ger.corp.intel.com>
References: <1388766184.20141.6.camel@x220>
 <20140103160812.8153.74401.stgit@warthog.procyon.org.uk>
 <9629.1388766864@warthog.procyon.org.uk>
In-Reply-To: <9629.1388766864@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Howells [mailto:dhowells@redhat.com]
> Sent: Friday, January 03, 2014 18:34
> To: Paul Bolle
> Cc: dhowells@redhat.com; akpm@linux-foundation.org; Greg Kroah-Hartman;
> Winkler, Tomas; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 7/7] Fix uninitialised variable warning in mei-amt-version.c
> 
> Paul Bolle <pebolle@tiscali.nl> wrote:
> 
> > But it turns out that call of mei_deinit() isn't needed at all. All of
> > the members of mei_cl will be set later in mei_init() and none will be
> > used before they are set. So we can simply drop this call of
> > mei_deinit()."
> >
> > Is that analysis (still) correct?
> 
> It looks true as the code stands.  Can you send me your patch?

Yes, the analysis is correct,  need to fix the typo in the title and but otherwise ACK.

Thanks
Tomas



