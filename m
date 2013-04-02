Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3DBXcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:32:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30097 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3DBXcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:32:14 -0400
X-AuditID: cbfee690-b7f656d0000007e3-fb-515b6a7c4a95
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>, "'Russ Dill'" <Russ.Dill@ti.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <009001ce2f84$beb22ea0$3c168be0$%choi@samsung.com>
 <20130402200257.GB8177@kroah.com> <515B41EA.8040704@ti.com>
 <20130402205451.GA2710@kroah.com>
In-reply-to: <20130402205451.GA2710@kroah.com>
Subject: RE: [PATCH 3.8-stable] regulator: core: Log when a device causes a
 voltage
Date: Wed, 03 Apr 2013 08:32:08 +0900
Message-id: <002301ce2ffa$4d7b0380$e8710a80$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4v5GVdPt8zPdaZSR2oGtZ2pjsmbgAFZ1qA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI93arOhAg43rGS3+zT7FZtG8eD2b
	xeVdc9gspl4/ymSxYOMjRgdWj/1z17B7vJz4m83j+I3tTB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZfRPmcpWcES4Yk/7f6YGxsX8XYycHBICJhJzLvxihLDFJC7cW8/WxcjFISSwjFFi/5P17DBF
	m3b0skMkFjFKnP7dwQjh/GWUeN/9jRmkik1AV+LY+i2sILaIgJfEjwN/wbqZBfIkLp5bzwTR
	sIBRYsOqBWBFnAJ6Em8W/QQq4uAQFgiVmDMlGSTMIqAqMftRE1gvr4CdxKqf16BsQYkfk++x
	QMzUkli/8zgThC0vsXnNW2aQMRIC6hKP/upCnGAk8ePSbqgTRCT2vXgHdrOEwCV2iX8nH7NB
	7BKQ+Db5EAtEr6zEpgPMEA9LShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJRe
	ZKJXnJhbXJqXrpecn7uJERKhE3Yw3jtgfYgxGWj9RGYp0eR8YITnlcQbGpsZWZiamBobmVua
	kSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHR07ptK+fk+nkRTuUd/yyW3T5m
	Is7gssI8M3JexVyXY2sdD0jpaCUvlXiw13b9ua0B+9husC0U/nQ4nu+95IStC761vFlwc+Lb
	lbtqHQt2GSveMbd8NG/bK5mNrDXLxN2W3lv7/m6MqHzz4+TjG+PjjE8e3qLgWbeu43IOd5DM
	qdIJzRwWcqZHlViKMxINtZiLihMB7mWvw+YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAd2arOhAg+NLLC3+zT7FZtG8eD2b
	xeVdc9gspl4/ymSxYOMjRgdWj/1z17B7vJz4m83j+I3tTB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWb0T5nKVnBEuGJP+3+mBsbF/F2MnBwSAiYSm3b0skPY
	YhIX7q1n62Lk4hASWMQocfp3ByOE85dR4n33N2aQKjYBXYlj67ewgtgiAl4SPw78BetmFsiT
	uHhuPRNEwwJGiQ2rFoAVcQroSbxZ9BOoiINDWCBUYs6UZJAwi4CqxOxHTWC9vAJ2Eqt+XoOy
	BSV+TL7HAjFTS2L9zuNMELa8xOY1b5lBxkgIqEs8+qsLcYKRxI9Lu6FOEJHY9+Id4wRGoVlI
	Js1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc/8+kdjCubLA4xCjA
	wajEw3viS1SgEGtiWXFl7iFGCQ5mJRHe02HRgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqc
	D0xNeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA2Cn2Mmfv
	zBUKvMc4v9y0nF/0gWO19PVk7zVOYlrHo26KVhTPvJKwtMzwqqjSnwvJE2QeMlq+VL0ruljz
	i86yFVG/kz+JySuJTa1kvaqcMyfirErnEfNZ7S4F/9tyJYNu8FbbvY08IbH4I4vkbNPsLs8l
	dS/X3VzHkvSQP+IRf1RF/96duw9WKbEUZyQaajEXFScCAPaOauRDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all.

> > >> ------------------
> > >>
> > >> From: "Russ Dill <Russ.Dill@ti.com>"
> > >>
> > >> commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream.
> > >
> > > Wait, no, this is NOT the commit id of this patch, please don't get
> this
> > > wrong.
> > >
> > > I've dropped this from my stable mbox, if Russ feels this should go to
> > > 3.8-stable, please send me the correct git id of the patch to apply.
> >
> > 9c7b4e8a8ad2624106fbf690fa97ab9c8c9bfa88 is the proper upstream commit.
> > This fixes a potential oops that was added in 3.8-rc4, and fixed
> > upstream in 3.9-rc1. I do think it belongs in stable.
> 
-> This is my fault. I will be more careful from now on


Thanks.

Best regards.




> -----Original Message-----
> From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.org]
> On Behalf Of Greg KH
> Sent: Wednesday, April 03, 2013 5:55 AM
> To: Russ Dill
> Cc: Jonghwan Choi; linux-kernel@vger.kernel.org; stable@vger.kernel.org;
> 'Mark Brown'
> Subject: Re: [PATCH 3.8-stable] regulator: core: Log when a device causes
> a voltage
> 
> On Tue, Apr 02, 2013 at 01:39:06PM -0700, Russ Dill wrote:
> > On 04/02/2013 01:02 PM, Greg KH wrote:
> > > On Tue, Apr 02, 2013 at 06:30:42PM +0900, Jonghwan Choi wrote:
> > >> 3.8-stable review patch.  If anyone has any objections, please let us
> know.
> > >>
> > >> ------------------
> > >>
> > >> From: "Russ Dill <Russ.Dill@ti.com>"
> > >>
> > >> commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream.
> > >
> > > Wait, no, this is NOT the commit id of this patch, please don't get
> this
> > > wrong.
> > >
> > > I've dropped this from my stable mbox, if Russ feels this should go to
> > > 3.8-stable, please send me the correct git id of the patch to apply.
> >
> > 9c7b4e8a8ad2624106fbf690fa97ab9c8c9bfa88 is the proper upstream commit.
> > This fixes a potential oops that was added in 3.8-rc4, and fixed
> > upstream in 3.9-rc1. I do think it belongs in stable.
> 
> Thanks, I've applied that commit now.
> 
> > Too bad I can't muck up the commit, then I'd owe you a beer. Might help
> > that shoulder of yours.
> 
> Yes, that would help it out, but probably not help me catch up with
> pending patches to apply :)
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

