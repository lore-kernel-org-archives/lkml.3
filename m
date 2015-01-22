Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbbAVJzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:55:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16525 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbAVJzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:55:12 -0500
Date: Thu, 22 Jan 2015 12:54:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Dudley Du <dudl@cypress.com>,
        dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Message-ID: <20150122095453.GL6507@mwanda>
References: <1421909406-1240-1-git-send-email-dudl@cypress.com>
 <20150122093129.GA7133@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122093129.GA7133@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 01:31:29AM -0800, Jeremiah Mahler wrote:
> I wasn't able to reproduce the sparse warning.  Was it for a specific
> architecture?  Perhaps include a link to the email sent by the kbuild
> test robot.

You need to add a "CF=-D__CHECK_ENDIAN__" to turn these on.

make C=2 CF=-D__CHECK_ENDIAN__

http://lwn.net/Articles/205624/

regards,
dan carpenter

