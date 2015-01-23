Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbbAWKCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:02:12 -0500
Received: from mwork.nabble.com ([162.253.133.43]:64106 "EHLO mwork.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbbAWKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:02:07 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2015 05:02:07 EST
Date: Fri, 23 Jan 2015 02:50:53 -0700 (MST)
From: "y.gribov" <y.gribov@samsung.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1422006653293-1027990.post@n7.nabble.com>
In-Reply-To: <54C16F99.2000006@oracle.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com> <54C042D2.4040809@oracle.com> <CAPAsAGyXo=AMCU-2TbrrY=MPorg+Nd+WYS5nCAcjELZs91r4AQ@mail.gmail.com> <CAPAsAGyMyq_anQjErLa=L-0K3KmghMjoqzi0AdZOADTAECn1HA@mail.gmail.com> <54C16F99.2000006@oracle.com>
Subject: Re: [PATCH v9 00/17] Kernel address sanitizer - runtime memory
 debugger.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to keep it going, here's a funny trace where kasan is catching issues
> in ubsan: :)

Thanks, I've filed an upstream PR for this
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=64741



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/RFC-PATCH-RESEND-next-00-21-Address-sanitizer-for-kernel-kasan-dynamic-memory-error-detector-tp898880p1027990.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
