Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaCKWjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:39:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:55958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaCKWjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,633,1389772800"; 
   d="scan'208";a="498018667"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc-next 3/3] mei: report consistently copy_from/to_user
 failures
Thread-Topic: [char-misc-next 3/3] mei: report consistently
 copy_from/to_user failures
Thread-Index: AQHPPXEQrOg2DeGJ+021kwjlZ1gccprceiLg
Date: Tue, 11 Mar 2014 22:39:03 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF8F5F6@HASMSX106.ger.corp.intel.com>
References: <1394542165-19362-1-git-send-email-tomas.winkler@intel.com>
	<1394542165-19362-3-git-send-email-tomas.winkler@intel.com>
 <20140311212943.3d9541f9@alan.etchedpixels.co.uk>
In-Reply-To: <20140311212943.3d9541f9@alan.etchedpixels.co.uk>
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



> On Tue, 11 Mar 2014 14:49:25 +0200
> Tomas Winkler <tomas.winkler@intel.com> wrote:
> 
> > From: Alexander Usyskin <alexander.usyskin@intel.com>
> >
> > Consistently display error on possible copy_from/to_user failures
> > and replace dev_dbg with dev_err
> 
> NAK
> 
> This allows users to flood the logs by deliberately causing lots of these
> failed to copy data error messages, and if they can flood the logs they
> can hide other stuff.
> 
> The -EFAULT cases should be consistent - but consistently *not* logged.

Yep, that's really looks like a possible exploit, please drop this patch.
Tomas
