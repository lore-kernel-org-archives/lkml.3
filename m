Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbbAPH0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:26:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62055 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAPH0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:26:39 -0500
X-AuditID: cbfee691-f79b86d000004a5a-1d-54b8bd2d04f7
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: david@fromorbit.com, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, a.sangwan@samsung.com
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
 <1421165126-3585-3-git-send-email-linkinjeon@gmail.com>
 <20150115122906.GC18876@bfoster.bfoster>
In-reply-to: <20150115122906.GC18876@bfoster.bfoster>
Subject: RE: [PATCH v8 2/11] xfs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Fri, 16 Jan 2015 16:26:36 +0900
Message-id: <005101d0315d$c31ad6e0$495084a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQI8HFfblg/gPWIGszLKUjAczsKp1gHJln/+AbRh1nebzpFi4A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWyRsSkSFd3744Qg8UNPBZLJ15itnj3ucpi
	y7F7jBbX795itpg57w6bxZ69J1ksLu+aw2bR2vOT3WJR3y1GB06PU4skPHbOusvu0XTmKLPH
	6gtbGT3e77vK5tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZk38vYCm4yVnRcbiHtYHxKnsX
	IyeHhICJROuZf4wQtpjEhXvr2boYuTiEBJYySjw7sJcNpmjz+z6oxCJGiU/XzzNBOH8ZJXZM
	uQc0ioODTUBb4s8WUZAGEQFfifvLP7KC1DALrGaUOD+lmxWiYQWjxM+D88F2cwqYSuz9MQ9s
	t7BAiMSGpY/A1rEIqEqcn7WRFcTmFbCUaP+4lB3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3
	zBCnKkjsOPuaEeIKJ4mpn9ugakQk9r14xwhyhIRAK4fE1BPf2SGWCUh8m3yIBeQDCQFZiU0H
	oOZIShxccYNlAqPELCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJ
	ERjnp/89m7iD8f4B60OMAhyMSjy8Dpt2hAixJpYVV+YeYjQFumgis5Rocj4wmeSVxBsamxlZ
	mJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4fuEtIwOpiY//7V0V
	G5jwx1RLRfLF5uSpqT2zfjJ4fj3PVfDieEiH9+avgf+vF4RWLJ2feXpVUKP3vz0Rib+v/Lpk
	b6QzNa/yIjPTya3NPEFPZ57SWWG+uF3kzwz/9NhHsevrY+ozez984exSP3S5/eoKXpY7cvuq
	Ej3XLnNh36jrk3ZK4+0nJZbijERDLeai4kQAJ+FMQ+4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAV3dvTtCDJa2s1osnXiJ2eLd5yqL
	LcfuMVpcv3uL2WLmvDtsFnv2nmSxuLxrDptFa89PdotFfbcYHTg9Ti2S8Ng56y67R9OZo8we
	qy9sZfR4v+8qm0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzJj8ewFLwU3Oio7DPawNjFfZuxg5OSQETCQ2v+9jg7DFJC7cWw9kc3EICSxilPh0/TwT
	hPOXUWLHlHtAHRwcbALaEn+2iII0iAj4Stxf/pEVpIZZYDWjxPkp3awQDSsYJX4enA+2glPA
	VGLvj3mMILawQIjEhqWPwNaxCKhKnJ+1kRXE5hWwlGj/uJQdwhaU+DH5HguIzSygJbF+53Em
	CFteYvOat8wQpypI7Dj7mhHiCieJqZ/boGpEJPa9eMc4gVFoFpJRs5CMmoVk1CwkLQsYWVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeRZ9I7GFc1WBxiFOBgVOLhnbFlR4gQa2JZcWXu
	IUYJDmYlEd6N24BCvCmJlVWpRfnxRaU5qcWHGE2BPp3ILCWanA9McHkl8YbGJmZGlkbmhhZG
	xuZK4rxK9m0hQgLpiSWp2ampBalFMH1MHJxSDYxmWW4q3mUbM0TXHJ08P77z58Lp6csZZ1yK
	n7kzf8f85MdbyoSXlPq352xL+pT2enOhMP93hv0zemRqvrjUZJpek/j2r6Q77+Kr5ZzXOYsr
	XyYzrl0v+dNIy329oZFhieyuu4l9W+v5DXL+flHi4k4p2jRRd9GhIsYA5jo9o3Mc353Lvi3Y
	eVeJpTgj0VCLuag4EQC1OfbvOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jan 14, 2015 at 01:05:17AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.
> >
> > 1) Make sure that both offset and len are block size aligned.
> > 2) Update the i_size of inode by len bytes.
> > 3) Compute the file's logical block number against offset. If the computed
> >    block number is not the starting block of the extent, split the extent
> >    such that the block number is the starting block of the extent.
> > 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
> >    towards right by len bytes. This step will make a hole of len bytes
> >    at offset.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Cc: Brian Foster<bfoster@redhat.com>
> > ---
> 
> Fixes look good (I assume nothing else changed between the few nits
> called out in v7) and survives overnight fsstress and fsx testing
> without any explosions:
Yes, I am also running test for long time, If there is any issue, will share.
Thanks for your review and help :)
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 

