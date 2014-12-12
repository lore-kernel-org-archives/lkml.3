Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966604AbaLLTpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:45:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52998 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933372AbaLLTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:45:40 -0500
Date: Fri, 12 Dec 2014 14:45:31 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: Bug Fixed?
To: nick <xerofoify@gmail.com>
CC: <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <1418413531.4845.23@mail.thefacebook.com>
In-Reply-To: <548B2D11.5030102@gmail.com>
References: <548B2D11.5030102@gmail.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-12_07:2014-12-12,2014-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=1749.24041094204
 compositescore=0.140620555742602 urlsuspect_oldscore=0.140620555742602
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.140620555742602 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412120180
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Dec 12, 2014 at 12:59 PM, nick <xerofoify@gmail.com> wrote:
> Greetings Chris and Josef,
> I am wondering if the bug at this URL, 
> https://urldefense.proofpoint.com/v1/url?u=https://bugzilla.kernel.org/show_bug.cgi?id%3D82251&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=LzvRKZOlBaBgUF3ZlMvZ0oV6t5RcfUy7yo7%2B9JU0i14%3D%0A&s=5d04890d0104f2e119d684146b556e93dc0e16cc7a5b83de7aca69239c0e963a 
> is fixed. If it's not I am
> a idea of the issue after tracing a little today :).
> Nick


Hi Nick,

Yes, this was a bug in our workqueue usage and it has been fixed.

-chris



