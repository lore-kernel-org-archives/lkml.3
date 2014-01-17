Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaAQHbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:31:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22014 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaAQHbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:31:36 -0500
Date: Fri, 17 Jan 2014 10:31:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, apw@canonical.com,
        gregkh@linuxfoundation.org, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH V2 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140117073112.GP7444@mwanda>
References: <1389728116-21337-1-git-send-email-kys@microsoft.com>
 <20140116094200.GA16328@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116094200.GA16328@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:42:01AM +0100, Olaf Hering wrote:
> On Tue, Jan 14, K. Y. Srinivasan wrote:
> 
> > +enum hv_fcopy_op {
> > +	START_FILE_COPY = 0,
> > +	WRITE_TO_FILE,
> > +	COMPLETE_FCOPY,
> > +	CANCEL_FCOPY,
> > +};
> > +
> > +struct hv_fcopy_hdr {
> > +	enum hv_fcopy_op operation;
> > +	uuid_le service_id0; /* currently unused */
> > +	uuid_le service_id1; /* currently unused */
> > +} __attribute__((packed));
> 
> Is enum a fixed size?

No, it's not.  The compiler has a lot of latitude in choosing the size
for enums.

regards,
dan carpenter

