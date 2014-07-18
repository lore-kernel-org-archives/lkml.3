Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030684AbaGRRDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:03:51 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38584 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030643AbaGRRDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:03:49 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
 from the basic I/O timeout
Thread-Index: AQHPoqnH4RnOBmJ/q0aQf1y8l+Zt2ZumhH4A
Date: Fri, 18 Jul 2014 17:03:47 +0000
Message-ID: <1405703026.30262.4.camel@dabdike.int.hansenpartnership.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
	 <20140718170030.GA31769@infradead.org>
In-Reply-To: <20140718170030.GA31769@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.103.107]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <2943970F8F8607439B3B7338ECD5C698@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 10:00 -0700, Christoph Hellwig wrote:
> On Wed, Jun 04, 2014 at 09:33:43AM -0700, K. Y. Srinivasan wrote:
> > Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to derive the
> > FLUSH_TIMEOUT from the basic I/O timeout. However, this patch did not use the
> > basic I/O timeout of the device. Fix this bug.
> > 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Looks good to me,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (it will need some changes to apply to my tree, but I'm happy to do that
> if I can get another review).
> 
> James, does this look fine to you?

Yes:

Reviewed-by: James Bottomley <JBottomley@Parallels.com>

James

