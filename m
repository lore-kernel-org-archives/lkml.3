Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbbALIzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:55:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:9626 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbbALIzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:55:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,742,1413270000"; 
   d="scan'208";a="649723742"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Julian Brost <linux-kernel@0x4a42.net>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-mei@linux.intel.com" <linux-mei@linux.intel.com>,
        "linux-kernel@i4.cs.fau.de" <linux-kernel@i4.cs.fau.de>,
        "fabian.hofmann@fau.de" <fabian.hofmann@fau.de>
Subject: RE: [PATCH 0/4] Documentation/misc-devices/mei: Fix formatting
Thread-Topic: [PATCH 0/4] Documentation/misc-devices/mei: Fix formatting
Thread-Index: AQHQLfp5BT9Hwfeyo0qKETeOBXWdL5y7yxQAgABjXtA=
Date: Mon, 12 Jan 2015 08:55:12 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B34B7FEE0@HASMSX106.ger.corp.intel.com>
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
 <20150112045736.GB19607@hudson.localdomain>
In-Reply-To: <20150112045736.GB19607@hudson.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Julian,
> 
> On Mon, Jan 12, 2015 at 12:58:05AM +0100, Julian Brost wrote:
> > This patch series fixes multiple formatting issues in the documentation for the
> > Intel MEI, including improperly formatted headlines and issues with spacing and
> > indentation.
> >
> > Julian Brost (4):
> >   Documentation/misc-devices/mei: Fix formatting of headings.
> >   Documentation/misc-devices/mei: Fix spacing around parentheses.
> >   Documentation/misc-devices/mei: Fix indentation of enumeration.
> >   Documentation/misc-devices/mei: Fix indentation of embedded code.
> >
> >  Documentation/misc-devices/mei/mei-client-bus.txt |  17 +--
> >  Documentation/misc-devices/mei/mei.txt            | 126 ++++++++++++----------
> >  2 files changed, 77 insertions(+), 66 deletions(-)
> >
> > --

> 
> Series looks good.
> 
> I'm glad I am not the only one with OCD around here :-)
> 
> Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>

Thanks for the cleanup

ACK

Tomas


