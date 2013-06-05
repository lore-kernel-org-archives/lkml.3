Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3FETgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:36:06 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:36033 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab3FETgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:36:04 -0400
Date: Wed, 5 Jun 2013 21:36:00 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.10.0-rc4 oops in scsi_lib.c:1196
Message-ID: <20130605193600.GB25024@samfundet.no>
References: <20130605191216.GA25024@samfundet.no>
 <CAKb7UvhygE9OHwZvqN=uXgoBfHsc3DGvSjoYv3yw7zuq3LaiFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb7UvhygE9OHwZvqN=uXgoBfHsc3DGvSjoYv3yw7zuq3LaiFQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:16:05PM -0400, Ilia Mirkin wrote:
>> It dies every time. 3.9.0 is fine.
> You need the patch at https://lkml.org/lkml/2013/5/19/75

Ah, I'm already down at 3.9.4 again; I mainly reported this in case it was
unknown. (But a patch from May 19 not being in 3.10-rc4 is maybe a bit
strange.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/

