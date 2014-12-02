Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaLBRvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:51:36 -0500
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:46489 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbaLBRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:51:35 -0500
Date: Tue, 2 Dec 2014 11:51:33 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge
 period
In-Reply-To: <940407620.22325.1417541552737.JavaMail.zimbra@efficios.com>
Message-ID: <alpine.DEB.2.11.1412021150460.19228@gentwo.org>
References: <alpine.DEB.2.11.1411281229350.11435@gentwo.org> <20141202164024.GA10918@htj.dyndns.org> <alpine.DEB.2.11.1412021049580.13039@gentwo.org> <20141202171102.GC10918@htj.dyndns.org> <940407620.22325.1417541552737.JavaMail.zimbra@efficios.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014, Mathieu Desnoyers wrote:

> If I understand correctly, __get_cpu_var() is being deprecated ?

Its gone in -next.

> If this_cpu_ptr() is semantically equivalent to __get_cpu_var(), we can do a
> wrapper in lttng-modules and move to the new name, no worries there.

Sure. Look at the conversion descriptions.

