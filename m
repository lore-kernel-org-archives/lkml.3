Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaILQL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:11:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51825 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:11:55 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9c-54131b47270e
Message-id: <1410538309.8852.30.camel@AMDC723>
Subject: Re: [PATCH v2] [media] v4l2-common: fix overflow in
 v4l_bound_align_image()
From: Maciej Matraszek <m.matraszek@samsung.com>
To: Greg KH <greg@kroah.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Fri, 12 Sep 2014 18:11:49 +0200
In-reply-to: <20140910171013.GA14048@kroah.com>
References: <1410367869-27688-1-git-send-email-m.matraszek@samsung.com>
 <20140910171013.GA14048@kroah.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xK7ru0sIhBlvOilpsnLGe1eLcghmM
	Fkt+7mKyeP3C0GLJ5PmsFpd3zWGz6NmwldXi4jp5i8Nv2lktPm35xmSxYOMjRgdujym/N7J6
	vH0Y4DHvZKDHkjeHWD36tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoEr4/WPZ8wFj1grFh7fw9zA
	eImli5GTQ0LAROL5px+sELaYxIV769m6GLk4hASWMkocOraaCSQhJPCZUWLrMnkQm1dAT2Le
	riXsILawQJhE5/o3YIPYBAwkNv/rB7NFBGQkOpbsAathFpjNLLF8gS+IzSKgKvHi+npmEJtT
	QF9i8co/bBDzcyQubfnBAlGvLjFp3iKgGg6gg5QlGvvdINYKSvyYfA+qRF5i85q3zBMYBWYh
	6ZiFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKi4csOxsXHrA4xCnAwKvHw
	cpwTDBFiTSwrrsw9xCjBwawkwqsoKhwixJuSWFmVWpQfX1Sak1p8iJGJg1OqgVHjcbX1oxQb
	5lQxl+Vm8gp6v2c8vPQrRLIt0Xez9PTU/xVrZ4Z5emvMVYhqNlu9/ION2ZcAy6vuZx+9C7wh
	84OlVCe0MvHvTem3D/8tP87zPWDSjbDAG58y72Rv5pVbonDZKPhU4cn7O43dXvrPqVJ9a3nl
	VEPvZGN3vtUmn3O9E5yzpPqzDymxFGckGmoxFxUnAgC8nxgRZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 10:10 -0700, Greg KH wrote:
> > Fixes: b0d3159be9a3 ("V4L/DVB (11901): v4l2: Create helper function for bounding and aligning images")
> > Signed-off-by: Maciej Matraszek <m.matraszek@samsung.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > ---
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

Hi Greg,

I'm really sorry for this mistake.
Do I understand correctly that it is just a missing
'Cc: <stable@vger.kernel.org>' line?
Are there any other issues?

Thanks for your patience,
Maciej Matraszek


