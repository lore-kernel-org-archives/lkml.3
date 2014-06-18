Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaFRNgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:36:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbaFRNf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:35:59 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-01-53a195b2437b
From: Chanho Park <chanho61.park@samsung.com>
To: "'Casey Schaufler'" <casey@schaufler-ca.com>
Cc: james.l.morris@oracle.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1403095304-15368-1-git-send-email-chanho61.park@samsung.com>
 <53A1937F.5090806@schaufler-ca.com>
In-reply-to: <53A1937F.5090806@schaufler-ca.com>
Subject: RE: [PATCH] Smack: separate smackfstransmute and smackfsroot
Date: Wed, 18 Jun 2014 22:35:45 +0900
Message-id: <000001cf8afa$357b8be0$a072a3a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG2sPXKe0mwxvUBU+7Hg+ZiPMyRhAFFspRbm55iinA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWyRsSkRHfT1IXBBlsfylrc2/aLzaLvcZDF
	5V1z2Cw+9Dxic2Dx+Pj0FovH0f2L2Dw+b5ILYI7isklJzcksSy3St0vgyjjd2sdUcJSvYtq2
	z2wNjB+4uxg5OSQETCTuLHnADmGLSVy4t56ti5GLQ0hgKaPEyiefmWGKrk/4wQqRWMQosfj8
	e7CEkMA/RonrfWA2m4CuxJbnrxhBbBEBPYk1G+6wgdjMAikSz7fvYISoz5dYv/4IWD2ngIHE
	r+4PrCC2sICrxLPzy1hAbBYBVYlVsxvALuIVsJT4/O0AC4QtKPFj8j0WiJlaEut3HmeCsOUl
	Nq95C3WogsSOs6+BdnEA3WAlcaVJD6JERGLfi3eMIPdLCBxjl/jT+5QNYpeAxLfJh1hA6iUE
	ZCU2HYAaIylxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpe
	cn7uJkZgJJ7+96x3B+PtA9aHGJOB1k9klhJNzgdGcl5JvKGxmZGFqYmpsZG5pRlpwkrivEkP
	k4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MG4XyfFi5VY7tvPx14lTda5/E9mwPb2Kz9hF
	02gC76ms4CsHnHfvXm3W0adgo17pLMm5Xtluhegh/Ru9Ez5tcymZnmBjLXW7hvNN78xen+Cj
	VfYvL5dvevZIfc1F1j2KWrMNNjZo9rOvklsZnM5TveOfRfa2qZU7bz2cIllZfOKccOkNVzcJ
	FiWW4oxEQy3mouJEABPkmKjaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd1NUxcGGyyaLmZxb9svNou+x0EW
	l3fNYbP40POIzYHF4+PTWyweR/cvYvP4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwhjHjdGsfU8FRvopp2z6zNTB+4O5i5OSQEDCRuD7hByuELSZx4d56ti5GLg4h
	gUWMEovPv2cGSQgJ/GOUuN4HZrMJ6Epsef6KEcQWEdCTWLPhDhuIzSyQIvF8+w5GiPp8ifXr
	j4DVcwoYSPzq/gC2QFjAVeLZ+WUsIDaLgKrEqtkN7CA2r4ClxOdvB1ggbEGJH5PvsUDM1JJY
	v/M4E4QtL7F5zVtmiEMVJHacfQ20iwPoBiuJK016ECUiEvtevGOcwCg0C8mkWUgmzUIyaRaS
	lgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP8mfQOxlUNFocYBTgYlXh4OXIXBAux
	JpYVV+YeYpTgYFYS4T1WvDBYiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBKSivJN7Q2MTM
	yNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgzKm6GLls3Y4qx17+SG11z
	vjU1pvfvWcWxeveTpSsF/nt8cw2KbyitangxIcJZNfXO548yP/12FkZMakxUeKTj4y/cyrx5
	6v3oH4u6Ga4r5djaFs3KEpty41ZM73muk69Zr072u/Xx6CPO0rsPHtr9nDjvpq/an1TPmpvG
	BvpKhR6L41KMFJyVWIozEg21mIuKEwHHbF9wNwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Casey Schaufler [mailto:casey@schaufler-ca.com]
> Sent: Wednesday, June 18, 2014 10:26 PM
> To: Chanho Park
> Cc: james.l.morris@oracle.com; linux-security-module@vger.kernel.org;
> linux-kernel@vger.kernel.org; Casey Schaufler
> Subject: Re: [PATCH] Smack: separate smackfstransmute and smackfsroot
> 
> On 6/18/2014 5:41 AM, Chanho Park wrote:
> > According to previous commit(e830b39: Smack: Add smkfstransmute mount
> option),
> > the smackfstransmute option is the smackfsroot option + transmute
> option.
> > I think it can be confused because the transmute option can only have
> "TRUE".
> > Before the patch, you cannot use the smackfsroot and the
> smackfstransmute at
> > the same time. If you use the options simultaenously, the previous
> option will
> > be omitted. In the below example, the smackfsroot option will be
> omitted.
> > mount -t tmpfs -o size=128M,smackfsroot=*,smackfstransmute=_ tmpfs
> /tmp
> >
> > After the patch, now you can use the smackfstransmute option like
> below:
> > mount -t tmpfs -o size=128M,smackfsroot=*,smackfstransmute=TRUE tmpfs
> /tmp
> >
> > Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> 
> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> The smackfsroot option behaves as intended.
> The smackfstransmute option behaves as intended.
> There is no case where you want to mark the root inode
> transmuting where you do not also want to set the
> Smack label of that inode. Making the smackfstransmute
> option require the smackfsroot option as well would be
> unnecessary and inconvenient.

If the smackfstransmute option was like that, we should prevent the two
options at the same time to avoid confusing.
At least, I think we need to provide a documentation for that.

Best Regards,
Chanho Park

