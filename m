Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab3BSRKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:10:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46237 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758479Ab3BSRKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:10:12 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH 4/4] regulator: palmas: Change the DT node property
 names to follow the convention
Thread-Topic: [PATCH 4/4] regulator: palmas: Change the DT node property
 names to follow the convention
Thread-Index: AQHODZb8EcxJDCPQKkyLFndA8TN3D5iAxYOAgACmrxA=
Date: Tue, 19 Feb 2013 17:10:01 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229BBB5C@DBDE01.ent.ti.com>
References: <1361164460-3251-1-git-send-email-j-keerthy@ti.com>
 <20130219124133.GC23508@opensource.wolfsonmicro.com>
In-Reply-To: <20130219124133.GC23508@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.112.245]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Tuesday, February 19, 2013 6:12 PM
> To: J, KEERTHY
> Cc: lgirdwood@gmail.com; linux-kernel@vger.kernel.org;
> gg@slimlogic.co.uk
> Subject: Re: [PATCH 4/4] regulator: palmas: Change the DT node property
> names to follow the convention
> 
> On Mon, Feb 18, 2013 at 10:44:20AM +0530, J Keerthy wrote:
> > DT node properties should not have "_". Replacing them by "-".
> >
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> 
> This must need an update to the binding document too, and probably any
> DT files that ended up getting merged for it?

I have sent a patch with the document update. That is the first patch in
The series.

Regards,
Keerthy
